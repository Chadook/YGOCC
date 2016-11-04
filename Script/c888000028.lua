--Vendeta Ace
function c888000028.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000028.splimit)
	c:RegisterEffect(e1)
	--Change ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71625222,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_COIN+CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c888000028.atktg)
	e2:SetOperation(c888000028.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--random swap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000590,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c888000028.ranop)
	c:RegisterEffect(e4)
	--lose lp
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e5:SetCountLimit(1)
	e5:SetOperation(c888000028.loseop)
	c:RegisterEffect(e5)
end
function c888000028.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x888) or se:GetHandler():IsSetCard(0x889)
end
function c888000028.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
end
function c888000028.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1,c2=Duel.TossCoin(tp,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	if c1+c2>0 then
		e1:SetValue(500)
	else
		e1:SetValue(-2000)
	end
	c:RegisterEffect(e1)
end
function c888000028.ranop(e,tp,eg,ep,ev,re,r,rp,chk)
	local pdc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local odc=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if pdc<=0 or odc<=0 then return end
	local pd=Duel.GetFieldGroup(tp,LOCATION_DECK,0):RandomSelect(tp,1)
	local od=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0):RandomSelect(1-tp,1)
	Duel.SendtoDeck(pd,1-tp,2,REASON_EFFECT)
	Duel.SendtoDeck(od,tp,2,REASON_EFFECT)
end
function c888000028.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x888)
end
function c888000028.loseop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c888000028.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
		Duel.SetLP(tp,Duel.GetLP(tp)-3000)
	end
end
