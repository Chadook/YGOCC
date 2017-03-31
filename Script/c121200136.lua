--Winter Spirit Jack
--  Idea: Alastar Rainford
--  Script: Shad3
--  Editor: Keddy
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()
local sc_id=0xa8d

function scard.initial_effect(c)
	--CounterAdd
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ATK/DEF
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(scard.b_cd)
	e4:SetTarget(scard.b_tg)
	e4:SetValue(scard.b_val)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--Reg op
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_DRAW)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetLabel(1)
	e6:SetOperation(scard.c_op)
	c:RegisterEffect(e6)
	--Counter
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetDescription(aux.Stringid(s_id,0))
	e7:SetLabelObject(e6)
	e7:SetCondition(scard.d_cd)
	e7:SetOperation(scard.d_op)
	c:RegisterEffect(e7)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then tc:AddCounter(0x1015,1) end
		tc=eg:GetNext()
	end
end

function scard.b_cd(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end

function scard.b_tg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x1015)~=0 and bc:IsSetCard(sc_id)
end

function scard.b_val(e,c)
	return c:GetCounter(0x1015)*-200
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("Counter A: " .. e:GetLabel())
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	Debug.Message("Counter B: " .. e:GetLabel())
end

function scard.d_cd(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("Counter C: " .. e:GetLabelObject():GetLabel())
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>0
end

function scard.d_op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Debug.Message("Counter D: " .. ct)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:Select(tp,1,1,nil)
	sg:GetFirst():AddCounter(0x1015,ct)
end