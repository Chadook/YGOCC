--Winter Spirit Nikoli
--  Idea: Alastar Rainford
--  Script: Shad3

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
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,scard.a_fil1,scard.a_fil2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(scard.a_val)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(scard.a_cd)
	e2:SetOperation(scard.a_op)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(s_id,2))
	e4:SetCountLimit(1)
	e4:SetCost(scard.b_cs)
	e4:SetTarget(scard.b_tg)
	e4:SetOperation(scard.b_op)
	c:RegisterEffect(e4)
	--ATK/DEF
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(scard.c_cd)
	e5:SetTarget(scard.c_tg)
	e5:SetValue(scard.c_val)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end

function scard.a_fil1(c)
	return c:IsFusionSetCard(sc_id)
end

function scard.a_fil2(c)
	return c:GetCounter(0x1015)>=3
end

function scard.a_sfil1(c,tp,ft)
	if c:IsFusionSetCard(sc_id) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(nil,true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(scard.a_sfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(scard.a_sfil2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end

function scard.a_sfil2(c,tp)
	return c:GetCounter(0x1015)>=3 and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end

function scard.a_val(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end

function scard.a_cd(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(scard.a_sfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,ft)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(s_id,0))
	local mg=Duel.SelectMatchingCard(tp,scard.a_sfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,ft)
	local tc=mg:GetFirst()
	local g=Duel.GetMatchingGroup(scard.a_sfil2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(s_id,1))
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		local sg=g:Select(tp,1,1,nil)
		mg:Merge(sg)
	else
		local sg=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		mg:Merge(sg)
	end
	Duel.SendtoGrave(mg,REASON_COST)
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1015,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1015,2,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end

function scard.c_cd(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end

function scard.c_tg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x1015)~=0 and bc:IsSetCard(sc_id)
end

function scard.c_val(e,c)
	return c:GetCounter(0x1015)*-200
end
