function c1498.initial_effect(c)
	c:SetUniqueOnField(1,0,1498)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1498,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,1498+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c1498.cost)
	e2:SetTarget(c1498.target)
	e2:SetOperation(c1498.operation)
	c:RegisterEffect(e2)
	--negate monster effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1498,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1498+EFFECT_COUNT_CODE_OATH)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCost(c1498.negcost)
	e3:SetCondition(c1498.negcon)
	e3:SetTarget(c1498.negtg)
	e3:SetOperation(c1498.negop)
	c:RegisterEffect(e3)
end
function c1498.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end	
function c1498.cfilter(c,e,tp)
	return c:IsSetCard(0x5DC) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c1498.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c1498.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1498.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1498.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1498.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)then
		 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1498.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1498.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c1498.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1498.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
